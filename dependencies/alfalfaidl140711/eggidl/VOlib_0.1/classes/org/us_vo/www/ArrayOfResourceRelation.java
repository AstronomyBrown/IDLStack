/**
 * ArrayOfResourceRelation.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ArrayOfResourceRelation  implements java.io.Serializable {
    private org.us_vo.www.ResourceRelation[] resourceRelation;

    public ArrayOfResourceRelation() {
    }


    /**
     * Gets the resourceRelation value for this ArrayOfResourceRelation.
     * 
     * @return resourceRelation
     */
    public org.us_vo.www.ResourceRelation[] getResourceRelation() {
        return resourceRelation;
    }


    /**
     * Sets the resourceRelation value for this ArrayOfResourceRelation.
     * 
     * @param resourceRelation
     */
    public void setResourceRelation(org.us_vo.www.ResourceRelation[] resourceRelation) {
        this.resourceRelation = resourceRelation;
    }

    public org.us_vo.www.ResourceRelation getResourceRelation(int i) {
        return this.resourceRelation[i];
    }

    public void setResourceRelation(int i, org.us_vo.www.ResourceRelation value) {
        this.resourceRelation[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfResourceRelation)) return false;
        ArrayOfResourceRelation other = (ArrayOfResourceRelation) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.resourceRelation==null && other.getResourceRelation()==null) || 
             (this.resourceRelation!=null &&
              java.util.Arrays.equals(this.resourceRelation, other.getResourceRelation())));
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
        if (getResourceRelation() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getResourceRelation());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getResourceRelation(), i);
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
        new org.apache.axis.description.TypeDesc(ArrayOfResourceRelation.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfResourceRelation"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resourceRelation");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceRelation"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceRelation"));
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
