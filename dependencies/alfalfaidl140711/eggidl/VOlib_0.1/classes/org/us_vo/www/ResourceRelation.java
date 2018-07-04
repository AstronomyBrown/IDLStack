/**
 * ResourceRelation.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ResourceRelation  implements java.io.Serializable {
    private java.lang.String relatedResourceIvoId;
    private java.lang.String relationshipType;
    private java.lang.String relatedResourceName;

    public ResourceRelation() {
    }


    /**
     * Gets the relatedResourceIvoId value for this ResourceRelation.
     * 
     * @return relatedResourceIvoId
     */
    public java.lang.String getRelatedResourceIvoId() {
        return relatedResourceIvoId;
    }


    /**
     * Sets the relatedResourceIvoId value for this ResourceRelation.
     * 
     * @param relatedResourceIvoId
     */
    public void setRelatedResourceIvoId(java.lang.String relatedResourceIvoId) {
        this.relatedResourceIvoId = relatedResourceIvoId;
    }


    /**
     * Gets the relationshipType value for this ResourceRelation.
     * 
     * @return relationshipType
     */
    public java.lang.String getRelationshipType() {
        return relationshipType;
    }


    /**
     * Sets the relationshipType value for this ResourceRelation.
     * 
     * @param relationshipType
     */
    public void setRelationshipType(java.lang.String relationshipType) {
        this.relationshipType = relationshipType;
    }


    /**
     * Gets the relatedResourceName value for this ResourceRelation.
     * 
     * @return relatedResourceName
     */
    public java.lang.String getRelatedResourceName() {
        return relatedResourceName;
    }


    /**
     * Sets the relatedResourceName value for this ResourceRelation.
     * 
     * @param relatedResourceName
     */
    public void setRelatedResourceName(java.lang.String relatedResourceName) {
        this.relatedResourceName = relatedResourceName;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ResourceRelation)) return false;
        ResourceRelation other = (ResourceRelation) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.relatedResourceIvoId==null && other.getRelatedResourceIvoId()==null) || 
             (this.relatedResourceIvoId!=null &&
              this.relatedResourceIvoId.equals(other.getRelatedResourceIvoId()))) &&
            ((this.relationshipType==null && other.getRelationshipType()==null) || 
             (this.relationshipType!=null &&
              this.relationshipType.equals(other.getRelationshipType()))) &&
            ((this.relatedResourceName==null && other.getRelatedResourceName()==null) || 
             (this.relatedResourceName!=null &&
              this.relatedResourceName.equals(other.getRelatedResourceName())));
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
        if (getRelatedResourceIvoId() != null) {
            _hashCode += getRelatedResourceIvoId().hashCode();
        }
        if (getRelationshipType() != null) {
            _hashCode += getRelationshipType().hashCode();
        }
        if (getRelatedResourceName() != null) {
            _hashCode += getRelatedResourceName().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ResourceRelation.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceRelation"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relatedResourceIvoId");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "relatedResourceIvoId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relationshipType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "relationshipType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relatedResourceName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "relatedResourceName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
