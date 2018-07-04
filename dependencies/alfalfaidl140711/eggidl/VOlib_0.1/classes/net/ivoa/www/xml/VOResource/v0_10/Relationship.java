/**
 * Relationship.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Relationship  implements java.io.Serializable {
    private net.ivoa.www.xml.VOResource.v0_10.RelationshipType relationshipType;
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName[] relatedResource;

    public Relationship() {
    }


    /**
     * Gets the relationshipType value for this Relationship.
     * 
     * @return relationshipType
     */
    public net.ivoa.www.xml.VOResource.v0_10.RelationshipType getRelationshipType() {
        return relationshipType;
    }


    /**
     * Sets the relationshipType value for this Relationship.
     * 
     * @param relationshipType
     */
    public void setRelationshipType(net.ivoa.www.xml.VOResource.v0_10.RelationshipType relationshipType) {
        this.relationshipType = relationshipType;
    }


    /**
     * Gets the relatedResource value for this Relationship.
     * 
     * @return relatedResource
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName[] getRelatedResource() {
        return relatedResource;
    }


    /**
     * Sets the relatedResource value for this Relationship.
     * 
     * @param relatedResource
     */
    public void setRelatedResource(net.ivoa.www.xml.VOResource.v0_10.ResourceName[] relatedResource) {
        this.relatedResource = relatedResource;
    }

    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getRelatedResource(int i) {
        return this.relatedResource[i];
    }

    public void setRelatedResource(int i, net.ivoa.www.xml.VOResource.v0_10.ResourceName value) {
        this.relatedResource[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Relationship)) return false;
        Relationship other = (Relationship) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.relationshipType==null && other.getRelationshipType()==null) || 
             (this.relationshipType!=null &&
              this.relationshipType.equals(other.getRelationshipType()))) &&
            ((this.relatedResource==null && other.getRelatedResource()==null) || 
             (this.relatedResource!=null &&
              java.util.Arrays.equals(this.relatedResource, other.getRelatedResource())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getRelationshipType() != null) {
            _hashCode += getRelationshipType().hashCode();
        }
        if (getRelatedResource() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getRelatedResource());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getRelatedResource(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Relationship.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Relationship"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relationshipType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "relationshipType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "RelationshipType"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relatedResource");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "relatedResource"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
